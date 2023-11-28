import { IndicatorStatus } from '../model/LoadingMoreBase';
// namespace LoadingMoreList {
  @Component
  export struct IndicatorWidget {
    /// Status of indicator
    status: IndicatorStatus;

    build() {
      if (this.status == IndicatorStatus.none)
        Column()
      else if (this.status == IndicatorStatus.fullScreenBusying)
        Column()
      else
        Column()
    }
  }
// }

// export default LoadingMoreList;