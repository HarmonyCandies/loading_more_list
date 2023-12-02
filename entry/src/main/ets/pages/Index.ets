


import router from '@ohos.router'


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
      description: 'Show how to build loading more WaterFlow quickly',
      route: 'pages/LoadingMoreWaterFlowDemo',
    },
    {
      description: 'Show how to build loading more List with custom indicator quickly',
      route: 'pages/LoadingMoreCustomIndicatorDemo',
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


