import { LoadingMoreList, IndicatorWidget, IndicatorStatus } from '@candies/loading_more_list'
import { TuChongRepository } from '../data/TuChongRepository';
import { FeedList } from '../data/TuChongSource';

@Entry
@Component
struct LoadingMoreWaterFlowDemo {
  @State listData: TuChongRepository = new TuChongRepository();

  aboutToAppear() {
    this.listData.lastItemIsLoadingMoreItem = false;
  }

  @Builder
  buildFooter() {
    if (!this.listData.hasMore)
      IndicatorWidget({
        indicatorStatus: IndicatorStatus.noMoreLoad,
      })
    else if (this.listData.indicatorStatus == IndicatorStatus.loadingMoreError)
      IndicatorWidget({
        indicatorStatus: IndicatorStatus.loadingMoreError,
        sourceList: this.listData,
      })
    else
      IndicatorWidget({
        indicatorStatus: IndicatorStatus.loadingMoreBusying,
      })
  }

  @Builder
  buildList() {
    WaterFlow({
      footer: () => this.buildFooter()
    }) {
      LazyForEach(this.listData, (item, index) => {
        FlowItem() {
          TuChongImageListItem({ item: item, index: index })
        }
      },
        (item, index) => {
          var feedList = item as FeedList;
          if ('post_id' in feedList) {
            return `${feedList.post_id}`;
          }
          return `${item}`
        }
      )
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(10)
    .rowsGap(5)
    .flexGrow(1)
    .onReachEnd(() => {
      this.listData.loadMore();
    })
  }

  build() {
    Navigation() {
      LoadingMoreList({
        sourceList: this.listData,
        builder: () => this.buildList(),
      })
    }
    .title('LoadingMoreWaterFlowDemo').titleMode(NavigationTitleMode.Mini)
  }
}


@Component
struct TuChongImageListItem {
  item: FeedList;
  index: number;

  hasImage(): boolean {
    return this.item.images.length != 0;
  }

  //   Size? imageRawSize;
  //
  //   Size get imageSize {
  //   if (!hasImage) {
  //   return const Size(0, 0);
  // }
  //   return Size(images![0].width!.toDouble(), images![0].height!.toDouble());
  // }
  //
  imageUrl(): string {
    if (!this.hasImage()) {
      return '';
    }

    return `https://photo.tuchong.com/${this.item.images[0].user_id}/f/${this.item.images[0].img_id}.jpg`;
  }

  avatarUrl() {
    return this.item.site.icon;
  }

  imageTitle() {
    if (!this.hasImage()) {
      return this.item.title;
    }

    return this.item.images[0].title;
  }

  imageDescription() {
    if (!this.hasImage()) {
      return this.item.content;
    }

    return this.item.images![0].description;
  }

  aboutToAppear() {
    // console.log(this.imageUrl);
  }

  getAspectRatio(): number {
    return this.item.images[0].width / this.item.images![0].height;
  }

  build() {
    Column() {
      if (this.hasImage())
        Image(this.imageUrl())
          .objectFit(ImageFit.Fill)
          .autoResize(true)
          .width('100%')
          .aspectRatio(this.getAspectRatio())
          .backgroundColor('#22808080')
      // .sourceSize({ width: this.item.images[0].width / 10, height: this.item.images[0].height / 10 })
      Divider()
    }
  }
}