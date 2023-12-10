# loading_more_list

快速支持列表，表格，瀑布流增加更多的效果。

| ![LoadingMoreList](https://github.com/HarmonyCandies/HarmonyCandies/blob/main/gif/loading_more_list/LoadingMoreList.gif)  |   ![LoadingMoreGrid](https://github.com/HarmonyCandies/HarmonyCandies/blob/main/gif/loading_more_list/LoadingMoreGrid.gif) |
| --- | --- |
| ![LoadingMoreWaterFlow](https://github.com/HarmonyCandies/HarmonyCandies/blob/main/gif/loading_more_list/LoadingMoreWaterFlow.gif)  |   ![LoadingMoreCustomIndicator](https://github.com/HarmonyCandies/HarmonyCandies/blob/main/gif/loading_more_list/LoadingMoreCustomIndicator.gif) |

- [loading\_more\_list](#loading_more_list)
  - [安装](#安装)
  - [列表状态](#列表状态)
    - [IndicatorStatus](#indicatorstatus)
  - [准备数据源](#准备数据源)
    - [LoadingMoreBase](#loadingmorebase)
  - [使用](#使用)
    - [导入引用](#导入引用)
    - [LoadingMoreList](#loadingmorelist)
  - [例子](#例子)
    - [列表(List)](#列表list)
    - [表格(Grid)](#表格grid)
    - [瀑布流(WaterFlow)](#瀑布流waterflow)
    - [自定状态组件](#自定状态组件)



## 安装

`ohpm install @candies/loading_more_list`



## 列表状态

### IndicatorStatus

我们一个列表一共有 `7` 种状态。

``` typescript
export enum IndicatorStatus {
  none, // 初始化状态
  loadingMoreBusying, // 正在加载更多数据的状态
  fullScreenBusying, // 列表第一次加载数据之前的全屏的加载动画状态
  loadingMoreError, // 加载更多失败状态
  fullScreenError, // 全屏加载失败的状态
  noMoreLoad,  // 已经没有更多数据的状态
  empty // 列表没有数据的状态
}
```

而它们又可以分成 `3` 种大的场景

1. 初始的状态
* `none`

2. 列表第一次加载无数据之前下状态
* `fullScreenBusying`
* `fullScreenError`
* `empty`


3. 列表有数据，在列表展示形式下的状态
* `loadingMoreBusying`
* `loadingMoreError`
* `noMoreLoad`

这 `3` 种的绘制是利用在数据源的最后手动添加一项来实现的。

关键代码是 `LoadingMoreBase` 中的 `totalCount` 和 `getData` 的方法。

```typescript
lastItemIsLoadingMoreItem: boolean = true;

totalCount(): number {
  return this.length + (this.lastItemIsLoadingMoreItem ? 1 : 0);
}

getData(index: number): T | LoadingMoreItem {
  if (0 <= index && index < this.length)
    return this[index];
  if (!this.hasMore) {
    return new NoMoreLoadItem();
  }
  else if (this.indicatorStatus == IndicatorStatus.loadingMoreError) {
    return new LoadingMoreErrorItem();
  }
  else {
    // auto load more
    if (this.indicatorStatus != IndicatorStatus.loadingMoreBusying) {
      this.loadMore();
    }
    return new LoadingMoreBusyingItem();
  }
}
```


## 准备数据源

### LoadingMoreBase

你需要继承 `LoadingMoreBase<T>` 来实现加载更多的数据源. 通过重写 `loadData` 方法来加载数据. 当没有数据的时候记得把 `hasMore` 设置为 `false`.

下面是一个数据源的例子
* 重写 `refresh` 方法来初始化初始的值，可以配合下拉刷新调用 `refresh` 方法来刷新整个列表。
* 重写 `loadData`方法来提供加载数据的逻辑，以及 `hasMore` 的判断。如果加载成功，使用 `this.addAll` 追加新加载的数据，并且返回 `true` ； 如果加载失败返回 `false` 。

``` typescript
import {
  LoadingMoreBase,
} from '@candies/loading_more_list'
import { FeedList, TuChongSource } from './TuChongSource';
import http from '@ohos.net.http';

export class TuChongRepository extends LoadingMoreBase<FeedList> {
  public  hasMore: boolean = true;
  page: number = 1;

  public async refresh(notifyStateChanged: boolean = false): Promise<boolean> {
    this.page = 1;
    this.hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  public async loadData(isLoadMoreAction: boolean): Promise<boolean> {
    try {
      let url = '';
      if (this.length == 0) {
        url = 'https://api.tuchong.com/feed-app';
      } else {
        let lastPostId = (this[this.length - 1] as FeedList).post_id;
        url =
          `https://api.tuchong.com/feed-app?post_id=${lastPostId}&page=${this.page}&type=loadmore`;
      }
      let request = http.createHttp();
      let response: http.HttpResponse = await request.request(url);

      var feedList = (JSON.parse(response.result as string) as TuChongSource).feedList;

      this.addAll(feedList);
      this.hasMore = !(feedList.length == 0 || this.length > 50);
      this.page++;
      return true;
      // test for loading more ui
      // return new Promise<boolean>((resolve) => {
      //   setTimeout(() => {
      //     this.addAll(feedList);
      //     this.hasMore = !(feedList.length == 0 || this.length > 20);
      //     this.page++;
      //     resolve(true);
      //   }, 2000);
      // });
    }
    catch (e) {
      return false;
    }
  }
}
```


## 使用

### 导入引用
``` typescript
import {
  LoadingMoreList,
  LoadingMoreBase,
  IndicatorWidget,
  IndicatorStatus,
} from '@candies/loading_more_list'
```

### LoadingMoreList

`LoadingMoreList` 是我们的加载更多组件，它的参数如下：

``` typescript
/// 列表，可以是 List，Grid 或者 WaterFlow
@BuilderParam
private builder: () => void;
/// 列表的数据源
@Link sourceList: LoadingMoreBase<any>;
/// 列表的状态创建器, 只针对 [IndicatorStatus.fullScreenBusying,IndicatorStatus.fullScreenError,IndicatorStatus.empty]
@BuilderParam
indicatorBuilder?: ($$: {
  indicatorStatus: IndicatorStatus,
  sourceList: LoadingMoreBase<any>,
}) => void = this.buildIndicator;
```

## 例子

准备一个简单的数据源。

``` typescript
import {
  LoadingMoreBase,
} from '@candies/loading_more_list'

export class ListData extends LoadingMoreBase<number> {
  hasMore: boolean = true;
  pageSize: number = 10;
  maxCount: number = 20;

  public async refresh(notifyStateChanged: boolean = false): Promise<boolean> {
    this.hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  async loadData(isLoadMoreAction: boolean): Promise<boolean> {
    // 模拟请求延迟 1 秒
    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
          var length = this.length;
          let list = [];
     
          for (let index = length; index < length + this.pageSize; index++)          {
            list.push(index);
          }
          this.addAll(list);
        
        if (this.length >= this.maxCount) {
          this.hasMore = false;
        }
        resolve(this.isSuccess);
      }, 1000);
    });
  }
}
```

### 列表(List)

我们只需要关注超出列表长度的元素构建的情况。如果在构建列表元素的时候发现这是一个 `LoadingMoreItem` ，那么就可以利用下面的方法创建对应的状态下的 `UI` 。


```typescript
          if (this.listData.isLoadingMoreItem(item))
            IndicatorWidget({
              indicatorStatus: this.listData.getLoadingMoreItemStatus(item),
              sourceList: this.listData,
            })
```


完整代码如下：

```typescript
import { LoadingMoreList, LoadingMoreBase, IndicatorWidget } from '@candies/loading_more_list'

@Entry
@Component
struct LoadingMoreListDemo {
  @State listData: ListData = new ListData();

  @Builder
  buildList() {
    List() {
      LazyForEach(this.listData, (item, index) => {
        ListItem() {
          // index == this.listData.length
          if (this.listData.isLoadingMoreItem(item))
            IndicatorWidget({
              indicatorStatus: this.listData.getLoadingMoreItemStatus(item),
              sourceList: this.listData,
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
```

在 `List` 触发 `onReachEnd` 回调的时候，你可以手动调用 `loadMore` 方法。当然你也可以不手动调用，因为 `LoadingMoreBase` 已经自动调用过了。区别就是如果加载更多失败了，你加了这个手动调用的话，你可以通过上拉，再次触发加载更多。否则，只能依靠比如点击再次去调用 `loadMore`。

### 表格(Grid)

跟列表的类似，不过要注意最后一个元素构建有点区别。你需要为最后一个元素 `GridItem` 设置 `columnStart` 和 `columnEnd` 来实现元素跨列，让它占用整个一行(当然了，这个是通常的情况，你也可以根据你自身的情况设置)

```typescript
import { LoadingMoreList, LoadingMoreBase, IndicatorWidget } from '@candies/loading_more_list'

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
      LazyForEach(this.listData, (item, index) => {
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
        (item, index) => {
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
        builder: this.buildList.bind(this),
      })
    }
    .title('LoadingMoreGridDemo').titleMode(NavigationTitleMode.Mini)
  }
}
```

### 瀑布流(WaterFlow)

官方的瀑布流提供了 `footer` 回调，可以用于创建最后一个元素的样式。

首先我们需要把 `lastItemIsLoadingMoreItem` 设置成 `false` 。

`this.listData.lastItemIsLoadingMoreItem = false;`

然后利用 `footer` 回调来创建加载更多的组件。


```typescript
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
```

完整代码如下:

 ```typescript
import { LoadingMoreList, IndicatorWidget, IndicatorStatus } from '@candies/loading_more_list'

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
      footer: this.buildFooter.bind(this)
    }) {
      LazyForEach(this.listData, (item, index) => {
        FlowItem() {
          TuChongImageListItem({ item: item, index: index })
        }
      },
        (item, index) => {
          var feedList = item as FeedList;
          if ('post_id' in feedList) {
            return feedList.post_id;
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
        builder: this.buildList.bind(this),
      })
    }
    .title('LoadingMoreWaterFlowDemo').titleMode(NavigationTitleMode.Mini)
  }
}
```

### 自定状态组件

如果我们不自定义状态组件的话，默认是提供 `IndicatorWidget`，为各种状态状态创建 `UI` 。

我们通过创建一个 `CustomIndicatorWidget`，并且通过 `indicatorBuilder` 回调以及对最后一个元素的处理，来创建自定义的状态效果。

完整代码如下：

```typescript
import {
  LoadingMoreList,
  LoadingMoreBase,
  IndicatorWidget,
  IndicatorStatus,
} from '@candies/loading_more_list'

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
              sourceList: this.listData,
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
  buildIndicator($$: {
    indicatorStatus: IndicatorStatus,
    sourceList: LoadingMoreBase<any>,
  }) {
    CustomIndicatorWidget({ indicatorStatus: $$.indicatorStatus, sourceList: $$.sourceList, })
  }

  build() {
    Navigation() {
      LoadingMoreList({
        sourceList: this.listData,
        builder: this.buildList.bind(this),
        indicatorBuilder: this.buildIndicator.bind(this),
      })
    }
    .title('LoadingMoreCustomIndicatorDemo').titleMode(NavigationTitleMode.Mini)
  }
}


@Component
export struct CustomIndicatorWidget {
  /// Source list based on the [LoadingMoreBase].
  indicatorStatus: IndicatorStatus;
  sourceList: LoadingMoreBase<any>;

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
      this.sourceList.errorRefresh();
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
      this.sourceList.errorRefresh();
    })
    else if (this.indicatorStatus == IndicatorStatus.noMoreLoad)
    Row() {
      Text('已经到了我的下线，不要再拖了',)
    }.justifyContent(FlexAlign.Center).width('100%').backgroundColor('#22808080').height(50)
    else
      Column()
  }
}
```
