import {
  LoadingMoreList,
  LoadingMoreBase,
  IndicatorWidget,
  IndicatorStatus,
} from '@ohos/loading_more_list'
import { ListData } from '../data/ListData';

@Entry
@Component
struct LoadingMoreCustomIndicatorDemo {
  @State listData: ListData = new ListData();

  @Builder
  buildList() {
    List() {
      LazyForEach(this.listData, (item, index) => {
        ListItem() {
          // index == this.listData.length
          if (this.listData.isLoadingMoreItem(item))
            CustomIndicatorWidget({
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

  @Builder
  buildIndicator(indicatorStatus: IndicatorStatus, errorRefresh?: () => Promise<boolean>) {
    CustomIndicatorWidget({ indicatorStatus: indicatorStatus, errorRefresh: errorRefresh })
  }

  build() {
    Navigation() {
      LoadingMoreList({
        sourceList: this.listData,
        builder: this.buildList.bind(this),
        indicatorBuilder: this.buildIndicator,
      })
    }
    .title('LoadingMoreCustomIndicatorDemo').titleMode(NavigationTitleMode.Mini)
  }
}


@Component
export struct CustomIndicatorWidget {
  /// Source list based on the [LoadingMoreBase].
  indicatorStatus: IndicatorStatus;
  errorRefresh?: () => Promise<boolean> | null;

  build() {
    if (this.indicatorStatus == IndicatorStatus.none)
      Column()
    else if (this.indicatorStatus == IndicatorStatus.fullScreenBusying)
    Row() {
      Text('正在加载...不要着急',)
      LoadingProgress().width(50).height(50).margin({ left: 10 })
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.fullScreenError)
    Row() {
      Text('好像出现了问题呢？点击重新刷新',)
    }.justifyContent(FlexAlign.Center)
    .width('100%').height('100%').onClick((event) => {
      if (this.errorRefresh != null) {
        this.errorRefresh();
      }
    })
    else if (this.indicatorStatus == IndicatorStatus.empty)
    Row() {
      Text('这里只有空气呀！',)
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreBusying)
    Row() {
      Text('正在加载...不要使劲拖了',)
      LoadingProgress().width(40).height(40).margin({ left: 10 })
    }.justifyContent(FlexAlign.Center).width('100%').height(50).backgroundColor('#22808080')
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreError)
    Row() {
      Text('网络有点不对劲？点击再次加载试试！',)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
    .backgroundColor('#22808080')
    .onClick((event) => {
      if (this.errorRefresh != null) {
        this.errorRefresh();
      }
    })
    else if (this.indicatorStatus == IndicatorStatus.noMoreLoad)
    Row() {
      Text('已经到了我的下线，不要再拖了',)
    }.justifyContent(FlexAlign.Center).width('100%').backgroundColor('#22808080').height(50)
    else
      Column()
  }
}

