import { LoadingMoreBase, IndicatorStatus } from '../viewmodel/LoadingMoreBase';
import { IndicatorWidget } from './IndicatorWidget';


@Component
export struct LoadingMoreList {
  /// The List/Grid/WaterFlow Component
  @BuilderParam
  private builder: () => void;
  /// Source list based on the [LoadingMoreBase].
  @Link sourceList: LoadingMoreBase<ESObject>;
  /// The builder for each [IndicatorStatus].
  ///
  /// You can handle cases that you need to customize, and return null result
  /// to fallback to the default indicator.
  ///
  /// Defaults to [IndicatorWidget].
  /// Only for [IndicatorStatus.fullScreenBusying,IndicatorStatus.fullScreenError,IndicatorStatus.empty]
  @BuilderParam
  indicatorBuilder: ($$: IndicatorParam) => void = this.buildIndicator;

  @Builder
  buildIndicator($$: IndicatorParam) {
    IndicatorWidget({
      indicatorStatus: $$.indicatorStatus,
      sourceList: $$.sourceList,
    })
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
    if (this.sourceList.indicatorStatus == IndicatorStatus.fullScreenBusying) {
      this.indicatorBuilder({
        indicatorStatus: this.sourceList.indicatorStatus,
        sourceList: this.sourceList,
      })
    } else if (this.sourceList.indicatorStatus == IndicatorStatus.fullScreenError) {
      this.indicatorBuilder({
        indicatorStatus: this.sourceList.indicatorStatus,
        sourceList: this.sourceList,
      })
    } else if (this.sourceList.indicatorStatus == IndicatorStatus.empty) {
      this.indicatorBuilder({
        indicatorStatus: this.sourceList.indicatorStatus,
        sourceList: this.sourceList,
      })
    } else {
      this.builder()
    }
  }
}

export interface IndicatorParam {
  indicatorStatus: IndicatorStatus;
  sourceList: LoadingMoreBase<ESObject>;
}