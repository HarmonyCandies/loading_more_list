

import deviceInfo from '@ohos.deviceInfo'
import display from '@ohos.display'
import router from '@ohos.router'
import common from '@ohos.app.ability.common';
import window from '@ohos.window';


@Entry
@Component
struct Index {
  title: string = 'loading_more_list demo';
  pages: Array<PageInfo> = [
    {
      description: 'Show how to build loading more List quickly',
      route: 'pages/LoadingMoreListDemo',
    },
    {
      description: 'Show how to build loading more Grid quickly',
      route: 'pages/LoadingMoreGridDemo',
    },
    {
      description: 'Show how to build TuChongImageListDemo quickly',
      route: 'pages/LoadingMoreWaterFlowDemo',
    },

  ]


  build() {
    Column() {
      Text(`${this.title}`)
      List() {
        ForEach(this.pages, (item, index) => {
          ListItem() {
            Text(`${index + 1}. ${item.description}`).maxLines(5).onClick((x) => {
              router.pushUrl({ url: item.route });
            }).width('100%')
          }.margin(10)
        })
      }.divider({ strokeWidth: 1, color: Color.Gray }).margin({ top: 10 })
    }
    .width('100%').height('100%')
  }
}

interface PageInfo {
  description: String;
  route: String;
}


