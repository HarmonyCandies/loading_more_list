import { LoadingMoreBase, } from '@candies/loading_more_list'

export class ListData extends LoadingMoreBase<number> {
  hasMore: boolean = true;
  /// mock request success
  isSuccess: boolean = false;
  pageSize: number = 10;
  maxCount: number = 20;

  public async refresh(notifyStateChanged: boolean = false): Promise<boolean> {
    this.hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  async loadData(isLoadMoreAction: boolean): Promise<boolean> {

    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
        // this.hasMore=false;
        // resolve(true);
        // return;
        let length = this.length;
        let list = new Array<number>();
        if (this.isSuccess) {
          for (let index = length; index < length + this.pageSize; index++) {
            list.push(index);
          }
          this.addAll(list);
        }

        if (this.length >= this.maxCount) {
          this.hasMore = false;
        }
        resolve(this.isSuccess);
         this.isSuccess = !this.isSuccess;
      }, 2000);
    });
  }
}

