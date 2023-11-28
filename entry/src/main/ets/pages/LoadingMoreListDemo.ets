import { LoadingMoreList, LoadingMoreBase, IndicatorStatus } from '@ohos/loading_more_list'

@Entry
@Component
struct LoadingMoreListDemo {
  @State listData: ListData = new ListData();

  aboutToAppear() {
    for (let index = 0; index < 10; index++) {
      this.listData.push(index)
    }
  }

  @Builder
  buildList() {
    List() {
      LazyForEach(this.listData, (item, index) => {
        ListItem() {
          Text(`${item}`,).align(Alignment.Center)
        }.height(100).width('100%')
      },
        (item, index) => {
          return item
        }
      )
    }
    .flexGrow(1)
    // .height(500)
    .onReachEnd(() => {
      this.listData.loadMore();
      console.log('loading more')
    })
  }

  build() {
    Navigation() {
      LoadingMoreList({
        sourceList: this.listData,
        builder: this.buildList.bind(this),
      })
    }
    .title('LoadingMoreListDemo').titleMode(NavigationTitleMode.Mini)
  }
}


class ListData extends LoadingMoreBase<number> {
  protected hasMore: boolean = true;

  async loadData(isLoadMoreAction: boolean): Promise<boolean> {

    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
        var length = this.length;

        for (let index = length; index < length + 10; index++) {
          this.push(index);
          this.notifyDataAdd(this.length-1);
        }
        resolve(true);
      }, 2000);
    });
  }
}