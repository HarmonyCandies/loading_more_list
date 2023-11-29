import { LoadingMoreBase } from '@ohos/loading_more_list/src/main/ets/model/LoadingMoreBase';
import { FeedList, TuChongSource } from './TuChongSource';
import http from '@ohos.net.http';

export class TuChongRepository extends LoadingMoreBase<FeedList> {
  protected hasMore: boolean = true;
  page: number = 1;

  public async refresh(notifyStateChanged: boolean = false): Promise<boolean> {
    this.page = 1;
    this.hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  public async loadData(isLoadMoreAction: boolean): Promise<boolean> {
    try {
      let url = '';
      if (this.length == 0) {
        url = 'https://api.tuchong.com/feed-app';
      } else {
        let lastPostId = (this[this.length - 1] as FeedList).post_id;
        url =
          `https://api.tuchong.com/feed-app?post_id=${lastPostId}&page=${this.page}&type=loadmore`;
      }
      let request = http.createHttp();
      let response: http.HttpResponse = await request.request(url);

      var feedList = (JSON.parse(response.result as string) as TuChongSource).feedList;
      // see load more clearly
      return new Promise<boolean>((resolve) => {
        setTimeout(() => {
          this.addAll(feedList);
          this.hasMore = !(feedList.length == 0 || this.length > 100);
          this.page++;
          resolve(true);
        }, 2000);
      });
    }
    catch (e) {
      return false;
    }
  }
}