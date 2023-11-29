export interface TuChongSource {
  is_history: boolean
  counts: number
  feedList: FeedList[]
  message: string
  more: boolean
  result: string
}

export interface FeedList {
  post_id: number
  type: string
  url: string
  site_id: string
  author_id: string
  published_at: string
  passed_time: string
  excerpt: string
  favorites: number
  comments: number
  rewardable: boolean
  parent_comments: string
  rewards: string
  views: number
  collected: boolean
  shares: number
  recommend: boolean
  delete: boolean
  update: boolean
  content?: string
  title: string
  image_count: number
  images: Image[]
  title_image?: TitleImage
  tags: string[]
  event_tags: string[]
  favorite_list_prefix: any[]
  reward_list_prefix: any[]
  comment_list_prefix: any[]
  data_type: string
  created_at: string
  sites: any[]
  site: Site
  recom_type: string
  rqt_id: string
  is_favorite: boolean
  app_url?: string
  text_img_urls?: string[]
  last_read?: boolean


}

export interface Image {
  img_id: number
  img_id_str: string
  user_id: number
  title: string
  excerpt: string
  width: number
  height: number
  description: string
}

export interface TitleImage {
  width: number
  height: number
  url: string
}

export interface Site {
  site_id: string
  type: string
  name: string
  domain: string
  description: string
  followers: number
  url: string
  icon: string
  is_bind_everphoto: boolean
  has_everphoto_note: boolean
  videos: number
  verified: boolean
  verifications: number
  verification_list: VerificationList[]
  is_following: boolean
}

export interface VerificationList {
  verification_type: number
  verification_reason: string
}
