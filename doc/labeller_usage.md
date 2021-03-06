labeller使用手册
---------------

Labeller系统目前支持Class Label和Word Label两种标注模式，在发布者和标注者使用方面均略有不同，对于task以及job对应的status也分别有不同的职责，详细说明如下：
****

###注册登录
  - 用户进入网站后点击左上角按钮进入注册页面。输入邮箱、密码、密码确认后点击注册即创建成功，默认为标注者角色；
  - 未登录的用户无法访问任何页面，游客对于任何资源的访问都会跳转到登录界面，登录用户可以修改自己的密码、邮箱，无法修改自己的帐号角色；
  - 登录右上角的状态栏会显示其登入邮箱以及帐号角色类型。


###标注功能说明
- 发布者与标注者登录后都会进入已经分配给自己的所有task页面，可以查看自己所有task当前的状态。当前尚未被对应发布者approve的task与已经approve的会分开显示；
- 标注者点击对应的task后可以进入标注页面，可以查看task对应job的名称、说明、截止时间、详细说明等内容，并对内容进行标注；
- 在class label中，每一个数据条目右侧对应了若干个label按钮，点击该条目所属类别对应的按钮后即标注成功，可随时更改自己的选择；
- 在word label中，标注者在左边数据中框选出需要标注的词句，鼠标移到中间的label按钮会提示“label as XXX”，确认无误后点击即可成功标注，按钮变为黄色的UNDO按钮，可以点击后取消先前的标注；
- 标注者完成每个task后可以点击标注页面上端的submit按钮，这样发布者将会看到submit状态，检查后可以选择approve（通过）或是reopen（不通过，继续标注）。

###发布者功能说明
- 发布者登录后点击左上角的jobs进入所有其创建的job页面，分别列出了未完成和已完成的jobs，发布者可以对已经发布的job进行删除和修改部分内容；
- 点击又上角的新建job按钮进入新建界面，填写job的名称、详细信息以及截止日期，上传的rawdata（原始数据）应以".txt"、".csv"、或".data"结尾，文件内容必须每一条数据占一行；
- 当创建class label job时，不用选择filter项，Labels中输入需要标注的标签类型，不同的标签之间用“|”来间隔，形如“有|没有”、“A类|B类|C类”；
- 当创建word label job时必须不填写Labels项，可以选择上传filter文件用基础数据集来过滤rawdata文件，filter文件格式为每个词语占一行的文本文件，格式未“txt”、“csv”或“data”；
- 在此版本中，job创建后会自动将上传的文件平均分配成若干个task给系统中所有的标注者每人一个。在改进版本中，发布者可以选择若干标注者来发布任务；
- 发布者可以进入job管理界面，查看所有task的状态，当task为submit等状态时可以选择approve、reopen等操作，并可以进入每个task的标注页面，查看标注任务的完成的具体情况。