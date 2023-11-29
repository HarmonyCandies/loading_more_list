import { LoadingMoreBase, IndicatorStatus } from '../model/LoadingMoreBase';
import { IndicatorWidget } from './IndicatorWidget';


@Component
export struct LoadingMoreList {
  @BuilderParam
  private builder: () => void;
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
  @BuilderParam
  indicatorBuilder?: (indicatorStatus: IndicatorStatus, errorRefresh?: () => Promise<boolean>) => void = this.buildIndicator;
  /// Whether to auto refresh with the [sourceList].
  ///
  /// Set to false if you want to handle the refresh action yourself.
  autoRefresh: boolean = true;

  @Builder
  buildIndicator(indicatorStatus: IndicatorStatus, errorRefresh?: () => Promise<boolean>) {
    IndicatorWidget({ indicatorStatus: indicatorStatus, errorRefresh: errorRefresh, })
  }

  aboutToAppear() {
    if (this.sourceList == undefined) {
      throw new Error('The sourceList should be initialized.');
    }

    if (this.sourceList.indicatorStatus == IndicatorStatus.none && this.sourceList.isEmpty) {
      this.sourceList.refresh(true);
    }
  }

  build() {
    if (this.sourceList.indicatorStatus == IndicatorStatus.fullScreenBusying)
      this.indicatorBuilder(IndicatorStatus.fullScreenBusying)
    else if (this.sourceList.indicatorStatus == IndicatorStatus.fullScreenError)
      this.indicatorBuilder(IndicatorStatus.fullScreenError, this.sourceList.errorRefresh)
    else if (this.sourceList.indicatorStatus == IndicatorStatus.empty)
      this.indicatorBuilder(IndicatorStatus.empty)
    else
      this.builder()
  }
}