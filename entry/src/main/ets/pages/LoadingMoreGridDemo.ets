import { LoadingMoreList, LoadingMoreBase, IndicatorWidget } from '@candies/loading_more_list'
import { ListData } from '../data/ListData';

@Entry
@Component
struct LoadingMoreGridDemo {
  @State listData: ListData = new ListData();

  aboutToAppear() {
    this.listData.pageSize = 50;
    this.listData.maxCount = 100;
  }

  @Builder
  buildList() {
    Grid() {
      LazyForEach(this.listData, (item:number, index) => {
        // index == this.listData.length
        if (this.listData.isLoadingMoreItem(item))
        GridItem() {
          IndicatorWidget({
            indicatorStatus: this.listData.getLoadingMoreItemStatus(item),
            sourceList: this.listData,
          })
        }
        // loading more item take one row, you can define it base on your case
        .columnStart(0).columnEnd(4)
        else
        GridItem() {
          Text(`${item}`,).align(Alignment.Center)
        }.height(100).width('100%')
      },
        (item:number, index) => {
          return `${item}`
        }
      )
    }
    .flexGrow(1)
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)

    // api10
    // .onReachEnd(() => {
    //   this.listData.loadMore();
    //
    // })
  }

  build() {
    Navigation() {
      LoadingMoreList({
        sourceList: this.listData,
        builder: (): void => this.buildList(),
      })
    }
    .title('LoadingMoreGridDemo').titleMode(NavigationTitleMode.Mini)
  }
}


