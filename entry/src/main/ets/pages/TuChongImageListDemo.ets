import { LoadingMoreList, IndicatorWidget } from '@ohos/loading_more_list'
import { TuChongRepository } from '../data/TuChongRepository';
import { FeedList } from '../data/TuChongSource';

@Entry
@Component
struct LoadingMoreListDemo {
  @State listData: TuChongRepository = new TuChongRepository();

  @Builder
  buildList() {
    List() {
      LazyForEach(this.listData, (item, index) => {
        ListItem() {
          if (this.listData.isLoadingMoreItem(item))
            IndicatorWidget({
              indicatorStatus: this.listData.getLoadingMoreItemStatus(item),
              errorRefresh: this.listData.errorRefresh
            })
          else
            TuChongImageListItem({ item: item, index: index })
        }.height(100).width('100%')
      },
        (item, index) => {
          var feedList = item as FeedList;
          if ('post_id' in feedList) {
            return feedList.post_id;
          }
          return item
        }
      )
    }
    .flexGrow(1)
    //.height(500)
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

  build() {
    Column() {
      Image(this.imageUrl()).objectFit(ImageFit.Cover).height(100).width('100%')
      Divider()
    }
  }
}