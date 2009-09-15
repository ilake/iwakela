# backend host / port
# 這裡設定了
# image 後端的位置
# 這邊可以讓我得到像 BACKOFFICE_IMAGE_HOST 這樣的常數
LoadConstant.do(File.join( RAILS_ROOT, 'config', 'backendhost.yml'))

