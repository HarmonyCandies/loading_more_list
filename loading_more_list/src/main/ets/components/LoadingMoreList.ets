import { LoadingMoreBase, IndicatorStatus } from '../model/LoadingMoreBase';


@Component
export struct LoadingMoreList {
  @BuilderParam
  private builder: (sourceList:LoadingMoreBase<any>) => void;
  /// Whether reach the edge to load more items
  onReachEdge: () => boolean;
  /// Source list based on the [LoadingMoreBase].
  @Link sourceList: LoadingMoreBase<any>;
  /// The builder for each [IndicatorStatus].
  ///
  /// You can handle cases that you need to customize, and return null result
  /// to fallback to the default indicator.
  ///
  /// Defaults to [IndicatorWidget].
  // @BuilderParam
  // indicatorBuilder: (status: IndicatorStatus) => void;
  /// Whether to auto refresh with the [sourceList].
  ///
  /// Set to false if you want to handle the refresh action yourself.
  autoRefresh: boolean = true;

  aboutToAppear() {
    if (this.sourceList == undefined) {
      throw new Error('The sourceList should be initialized.');
    }

    if (this.sourceList.indicatorStatus == IndicatorStatus.none && this.sourceList.isEmpty) {
      this.sourceList.refresh(true);
    }
  }

  build() {
    Column() {
      Column() {
        if (this.sourceList.indicatorStatus == IndicatorStatus.fullScreenBusying || this.sourceList.indicatorStatus == IndicatorStatus.empty)
        // this.indicatorBuilder(this.indicatorStatus)
          Text('loading....')
        else
          this.builder(this.sourceList)
        if (this.sourceList.indicatorStatus == IndicatorStatus.loadingMoreBusying || this.sourceList.indicatorStatus == IndicatorStatus.noMoreLoad || this.sourceList.indicatorStatus == IndicatorStatus.loadingMoreError)
        // this.indicatorBuilder(this.indicatorStatus)
          Text('加载更多....')
      }
    }.parallelGesture(PanGesture({
      direction: PanDirection.Down
    }).onActionUpdate((event?: GestureEvent) => {

    }))
  }
}