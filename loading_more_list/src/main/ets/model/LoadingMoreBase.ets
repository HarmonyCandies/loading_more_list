export enum IndicatorStatus {
  none,
  loadingMoreBusying,
  fullScreenBusying,
  loadingMoreError,
  fullScreenError,
  noMoreLoad,
  empty
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

///
export abstract class LoadingMoreBase<T> extends DataSourceBase<T> {
  protected abstract hasMore: boolean;
  private isLoading: boolean = false;
  indicatorStatus: IndicatorStatus = IndicatorStatus.none;

  public abstract loadData(isLoadMoreAction: boolean): Promise<boolean>;


  public async loadMore(): Promise<boolean> {
    let preStatus = this.indicatorStatus;
    this.indicatorStatus = IndicatorStatus.loadingMoreBusying;
    if (preStatus != this.indicatorStatus) {
      // _onStateChanged(this);
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
      this.indicatorStatus = IndicatorStatus.none;
      if (this.length == 0) {
        this.indicatorStatus = IndicatorStatus.empty;
      }
    } else {
      if (this.indicatorStatus == IndicatorStatus.fullScreenBusying) {
        this.indicatorStatus = IndicatorStatus.fullScreenError;
      } else if (this.indicatorStatus == IndicatorStatus.loadingMoreBusying) {
        this.indicatorStatus = IndicatorStatus.loadingMoreError;
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
    return await this.innerLoadData(false);
  }
}

