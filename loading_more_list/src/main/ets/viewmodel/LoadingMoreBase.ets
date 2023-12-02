export enum IndicatorStatus {
  none,
  loadingMoreBusying,
  fullScreenBusying,
  loadingMoreError,
  fullScreenError,
  noMoreLoad,
  empty
}

export class LoadingMoreItem {
}

export class LoadingMoreBusyingItem extends LoadingMoreItem {
  toString(): string {
    return 'LoadingMoreBusyingItem';
  }
}

export class LoadingMoreErrorItem extends LoadingMoreItem {
  toString(): string {
    return 'LoadingMoreErrorItem';
  }
}

export class NoMoreLoadItem extends LoadingMoreItem {
  toString(): string {
    return 'NoMoreLoadItem';
  }
}

export class DataSourceBase<T> extends Array<T> implements IDataSource {
  // IDataSource start
  private listeners: DataChangeListener[] = [];

  get isEmpty(): boolean {
    return this.length == 0
  }

  totalCount(): number {
    return this.length;
  }

  getData(index: number): T {
    return this[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const position = this.listeners.indexOf(listener);
    if (position >= 0) {
      this.listeners.splice(position, 1);
    }
  }

  // IDataSource end

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    })
  }
}

/// loading more base class
export abstract class LoadingMoreBase<T> extends DataSourceBase<T | LoadingMoreItem> {
  public  abstract hasMore: boolean;
  private isLoading: boolean = false;
  indicatorStatus: IndicatorStatus = IndicatorStatus.none;
  lastItemIsLoadingMoreItem: boolean = true;

  totalCount(): number {
    return this.length + (this.lastItemIsLoadingMoreItem ? 1 : 0);
  }

  getData(index: number): T | LoadingMoreItem {
    if (0 <= index && index < this.length)
      return this[index];
    if (!this.hasMore) {
      return new NoMoreLoadItem();
    }
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreError) {
      return new LoadingMoreErrorItem();
    }
    else {
      // auto load more
      if (this.indicatorStatus != IndicatorStatus.loadingMoreBusying) {
        this.loadMore();
      }
      return new LoadingMoreBusyingItem();
    }
  }

  public abstract loadData(isLoadMoreAction: boolean): Promise<boolean>;


  public async loadMore(): Promise<boolean> {
    let preStatus = this.indicatorStatus;
    this.indicatorStatus = IndicatorStatus.loadingMoreBusying;
    if (preStatus != this.indicatorStatus) {
      // _onStateChanged(this);
      this.notifyDataDelete(this.length);
    }
    return await this.innerLoadData(true);
  }

  private async innerLoadData(isLoadMoreAction: boolean = false): Promise<boolean> {
    if (this.isLoading || !this.hasMore) {
      return true;
    }

    this.isLoading = true;
    let isSuccess = await this.loadData(isLoadMoreAction);
    this.isLoading = false;
    if (isSuccess) {
      if (this.length == 0) {
        this.indicatorStatus = IndicatorStatus.empty;
      } else {
        this.indicatorStatus = IndicatorStatus.none;
      }
    } else {
      if (this.indicatorStatus == IndicatorStatus.fullScreenBusying) {
        this.indicatorStatus = IndicatorStatus.fullScreenError;
      } else if (this.indicatorStatus == IndicatorStatus.loadingMoreBusying) {
        this.indicatorStatus = IndicatorStatus.loadingMoreError;
        // refresh ui
        if (this.lastItemIsLoadingMoreItem) {
          this.notifyDataDelete(this.length);
        }
      }
    }
    if (!this.hasMore) {
      // refresh ui
      if (this.lastItemIsLoadingMoreItem) {
        this.notifyDataDelete(this.length);
      }
    }
    // _onStateChanged(this);
    return isSuccess;
  }


  public async refresh(notifyStateChanged: boolean = false): Promise<boolean> {
    if (notifyStateChanged) {
      // clear();
      this.length = 0;
      this.indicatorStatus = IndicatorStatus.fullScreenBusying;
      //_onStateChanged(this);
    }
    this.hasMore = true;
    return await this.innerLoadData(false);
  }

  public async errorRefresh(): Promise<boolean> {
    if (this.isEmpty) {
      return this.refresh(true);
    }
    return this.loadMore();
  }

  isLoadingMoreItem(item: any): boolean {
    if (item instanceof LoadingMoreItem) {
      return true;
    }
    return false;
  }

  getLoadingMoreItemStatus(item: any): IndicatorStatus {
    if (item instanceof LoadingMoreBusyingItem) {
      return IndicatorStatus.loadingMoreBusying;
    }
    else if (item instanceof LoadingMoreErrorItem) {
      return IndicatorStatus.loadingMoreError;
    }
    else if (item instanceof NoMoreLoadItem) {
      return IndicatorStatus.noMoreLoad;
    }
    return IndicatorStatus.none;
  }

  addAll(list: Array<T>): void {
    var length = this.length;
    if (length != 0 && this.lastItemIsLoadingMoreItem) {
      this.notifyDataDelete(length);
    }

    this.push(...list);
    for (let index = length; index < this.length; index++) {
      this.notifyDataAdd(index);
    }
  }
}

