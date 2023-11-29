import { IndicatorStatus, LoadingMoreBase } from '../model/LoadingMoreBase';

// namespace LoadingMoreList {
@Component
export struct IndicatorWidget {
  /// Source list based on the [LoadingMoreBase].
  indicatorStatus: IndicatorStatus;
  errorRefresh?: () => Promise<boolean> | null;

  build() {
    if (this.indicatorStatus == IndicatorStatus.none)
      Column()
    else if (this.indicatorStatus == IndicatorStatus.fullScreenBusying)
    Row() {
      Text('Loading...',)
      LoadingProgress().width(50).height(50).margin({ left: 10 })
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.fullScreenError)
    Row() {
      Text('Loading failed! click to refresh',)
    }.justifyContent(FlexAlign.Center)
    .width('100%').height('100%').onClick((event) => {
      if (this.errorRefresh != null) {
        this.errorRefresh();
      }
    })
    else if (this.indicatorStatus == IndicatorStatus.empty)
    Row() {
      Text('It\'s empty here!',)
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreBusying)
    Row() {
      Text('Loading...',)
      LoadingProgress().width(50).height(50).margin({ left: 10 })
    }.justifyContent(FlexAlign.Center)
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreError)
      Text('Loading failed! click to reload.',).onClick((event) => {
        if (this.errorRefresh != null) {
          this.errorRefresh();
        }
      })
    else if (this.indicatorStatus == IndicatorStatus.noMoreLoad)
      Text('No more content!',)
    else
      Column()
  }
}

// }

// export default LoadingMoreList;