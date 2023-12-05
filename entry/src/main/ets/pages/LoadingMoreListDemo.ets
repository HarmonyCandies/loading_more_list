import { LoadingMoreList, IndicatorWidget } from '@candies/loading_more_list'
import { ListData } from '../data/ListData';

@Entry
@Component
struct LoadingMoreListDemo {
  @State listData: ListData = new ListData();

  @Builder
  buildList() {
    List() {
      LazyForEach(this.listData, (item, index) => {
        ListItem() {
          // index == this.listData.length
          if (this.listData.isLoadingMoreItem(item))
            IndicatorWidget({
              indicatorStatus: this.listData.getLoadingMoreItemStatus(item),
              errorRefresh: this.listData.errorRefresh
            })
          else
            Text(`${item}`,).align(Alignment.Center).height(100)
        }.width('100%')
      },
        (item, index) => {
          return `${item}`
        }
      )
    }
    .flexGrow(1)
    .onReachEnd(() => {
      this.listData.loadMore();

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




