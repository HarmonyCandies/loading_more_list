

import deviceInfo from '@ohos.deviceInfo'
import display from '@ohos.display'
import router from '@ohos.router'
import common from '@ohos.app.ability.common';
import window from '@ohos.window';


@Entry
@Component
struct Index {
  title: string = 'pull_to_refresh_notification demo';
  pages: Array<PageInfo> = [
    {
      description: 'Show how to use pull to refresh notification to build a pull refresh header,and hide it on refresh done',
      route: 'pages/LoadingMoreListDemo',
    },
  ]


  build() {
    Column() {
      Text(`${this.title}`)
      List() {
        ForEach(this.pages, (item, index) => {
          ListItem() {
            Text(`${index + 1}. ${item.description}`).onClick((x) => {
              router.pushUrl({ url: item.route });
            })
          }.width('100%')
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


