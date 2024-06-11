import { IndicatorStatus, LoadingMoreBase } from '../viewmodel/LoadingMoreBase';

// namespace LoadingMoreList {
@Component
export struct IndicatorWidget {
  /// Source list based on the [LoadingMoreBase].
  indicatorStatus: IndicatorStatus = IndicatorStatus.none;
  sourceList: LoadingMoreBase<ESObject> | null = null;

  build() {
    if (this.indicatorStatus == IndicatorStatus.none) {
      Column()
    } else if (this.indicatorStatus == IndicatorStatus.fullScreenBusying)
    Row() {
      Text('Loading...',)
      LoadingProgress().width(50).height(50).margin({ left: 10 })
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.fullScreenError)
    Row() {
      Text('Loading failed! click to refresh',)
    }.justifyContent(FlexAlign.Center)
    .width('100%').height('100%').onClick((event) => {
      this.sourceList?.errorRefresh();
    })
    else if (this.indicatorStatus == IndicatorStatus.empty)
    Row() {
      Text('It\'s empty here!',)
    }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreBusying)
    Row() {
      Text('Loading...',)
      LoadingProgress().width(40).height(40).margin({ left: 10 })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
    .backgroundColor('#22808080')
    else if (this.indicatorStatus == IndicatorStatus.loadingMoreError)
    Row() {
      Text('Loading failed! click to reload.',)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
    .backgroundColor('#22808080')
    .onClick((event) => {
      this.sourceList?.errorRefresh();
    })
    else if (this.indicatorStatus == IndicatorStatus.noMoreLoad)
    Row() {
      Text('No more content!',)
    }.justifyContent(FlexAlign.Center).width('100%').backgroundColor('#22808080').height(50)
    else {
      Column()
    }
  }
}

// }

// export default LoadingMoreList;