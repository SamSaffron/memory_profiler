# MemoryProfiler

A memory profiler for MRI head

[![Build Status](https://travis-ci.org/SamSaffron/memory_profiler.png?branch=master)](https://travis-ci.org/SamSaffron/memory_profiler)

## Installation

Add this line to your application's Gemfile:

    gem 'memory_profiler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memory_profiler

## Usage

```
require 'memory_profiler'
report = MemoryProfiler.report do
  # run your code here
end

report.pretty_print
```

Example Session:

You can easily use memory_profiler to profile require impact of a gem, for example:


```
pry> require 'memory_profiler'
pry> MemoryProfiler.report{ require 'mime-types'  }.pretty_print
Total allocated 82375
Total retained 22618

allocated memory by gem
-----------------------------------
mime-types-2.0 x 3668277
2.1.0-github/lib x 2035704
rubygems x 305879
other x 40

allocated memory by file
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb x 3391763
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb x 2021853
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb x 285433
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb x 227033
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb x 48663
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb x 18597
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so x 8200
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so x 2463
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems.rb x 2218
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb x 1169
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/defaults.rb x 520
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb x 417
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb x 409
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb x 361
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb x 241
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb x 200
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json.rb x 120
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_gem.rb x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/version.rb x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime-types.rb x 40
(pry) x 40

allocated memory by location
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1985709
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 927503
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 827676
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 499525
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:625 x 281047
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 265920
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 265920
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:523 x 265920
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 222705
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:215 x 218105
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 62688
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 52728
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 48503
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:60 x 33480
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:62 x 10906
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so:0 x 8200
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:30 x 4388
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:239 x 3715
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:28 x 3237
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so:0 x 2463
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:266 x 2428
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:61 x 2339
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems.rb:1089 x 2218
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:68 x 1506
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:36 x 800
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:330 x 800
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:0 x 627
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:124 x 609
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/defaults.rb:39 x 520
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:15 x 377
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb:4 x 369
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:225 x 209
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:361 x 201
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:95 x 201
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:299 x 201
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:60 x 174
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:1420 x 169
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:283 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:199 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:87 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:218 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:20 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:300 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:22 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:204 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb:69 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:194 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:294 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:222 x 161
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb:12 x 161

allocated objects by gem
-----------------------------------
mime-types-2.0 x 56564
2.1.0-github/lib x 22210
rubygems x 3600
other x 1

allocated objects by file
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb x 56237
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb x 21978
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb x 3388
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb x 291
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb x 169
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so x 124
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems.rb x 53
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so x 37
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb x 26
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb x 24
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/defaults.rb x 13
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb x 7
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb x 6
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb x 5
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb x 5
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json.rb x 3
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb x 3
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_gem.rb x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/version.rb x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime-types.rb x 1
(pry) x 1

allocated objects by location
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 21337
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 21095
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 9972
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:523 x 6648
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 6648
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 6648
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3307
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 2955
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:625 x 1663
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:60 x 837
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 312
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 287
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so:0 x 124
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:62 x 82
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems.rb:1089 x 53
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:28 x 39
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so:0 x 37
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:61 x 23
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:266 x 22
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:330 x 20
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:36 x 20
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:68 x 13
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/defaults.rb:39 x 13
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:124 x 12
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:239 x 8
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:0 x 6
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb:4 x 6
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:15 x 4
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:30 x 4
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:215 x 3
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:1747 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:225 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/version.rb:155 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:361 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:71 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_gem.rb:39 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:299 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:60 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:1269 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:95 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:97 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb:12 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb:1 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:78 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb:7 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:91 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:87 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:79 x 1

retained memory by gem
-----------------------------------
mime-types-2.0 x 1496813
2.1.0-github/lib x 519954
rubygems x 76195

retained memory by file
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb x 1447316
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb x 516679
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb x 75946
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb x 48583
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so x 2263
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so x 892
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb x 577
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb x 297
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb x 169
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb x 40

retained memory by location
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 516181
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 499525
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 414007
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:625 x 280878
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 132960
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:523 x 66480
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 58151
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 52728
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 48503
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 17795
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so:0 x 2263
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so:0 x 892
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:239 x 577
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:15 x 257
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:124 x 169
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:122 x 89
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:46 x 89
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:132 x 89
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:33 x 89
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:71 x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:1269 x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:266 x 80
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:30 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:60 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:0 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:74 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:75 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:76 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:77 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:78 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb:75 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb:3 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb:4 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb:12 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:97 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:95 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:361 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:299 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:3 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:59 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:126 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:3 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:119 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:115 x 40
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:106 x 40

retained objects by gem
-----------------------------------
mime-types-2.0 x 15211
2.1.0-github/lib x 7089
rubygems x 318

retained objects by file
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb x 14918
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb x 7045
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb x 315
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb x 289
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so x 32
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so x 9
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb x 1

retained objects by location
-----------------------------------
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 7035
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 4987
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 3324
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 2955
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:625 x 1662
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:523 x 1662
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 312
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 300
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 287
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/generator.so:0 x 32
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 15
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/x86_64-linux/json/ext/parser.so:0 x 9
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:71 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:266 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/specification.rb:1269 x 2
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:30 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:60 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:75 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:46 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:33 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:76 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:74 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:77 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:78 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:0 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types.rb:75 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:3 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:59 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader.rb:239 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:15 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/basic_specification.rb:124 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/version.rb:3 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/generic_object.rb:4 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/ext.rb:12 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:97 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:95 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:361 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:299 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/loader_path.rb:3 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:132 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:126 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:122 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:119 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:115 x 1
/home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:106 x 1


Allocated String Report
-----------------------------------
"application" x 12050
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 4820
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 2410
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 2410
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 2410
"" x 6669
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 6648
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 11
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:266 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:71 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:72 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:69 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:0 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_gem.rb:39 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:70 x 1
"/" x 3342
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:523 x 3324
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 13
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:60 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 1
"encoding" x 3336
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 3324
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 10
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:60 x 1
"registered" x 3328
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 3324
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 4
"content-type" x 3327
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 3324
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3
"references" x 2944
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 2940
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 4
"IANA" x 2824
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1412
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 1412
"base64" x 1529
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1525
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 1
"audio" x 1500
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 600
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 300
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 300
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 300
"video" x 940
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 376
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 188
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 188
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 188
"extensions" x 882
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 878
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 4
"text" x 772
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 308
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 154
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 154
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 154
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 2
"image" x 710
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 284
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 142
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 142
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 142
"to_json" x 414
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:60 x 411
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3
"message" x 210
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 84
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 42
"multipart" x 210
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 84
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 42
"\n" x 197
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 194
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:79 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:78 x 1
"model" x 150
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 60
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 30
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 30
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 30
"[Murata]" x 148
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 74
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 74
"obsolete" x 135
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 130
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 5
"use-instead" x 111
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 108
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3
"  end\n" x 90
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 90
"    end\n" x 81
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 81
"example" x 80
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 16
"8bit" x 70
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 67
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 2
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 1
"quoted-printable" x 66
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 62
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 3
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:71 x 1
"  #\n" x 54
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 54
"LTSW" x 49
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 49
"1d-interleaved-parityfec" x 48
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 24
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"rtx" x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 1
"[W3C]" x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 21
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 21
"encaprtp" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"parityfec" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
"RFC4856" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 20
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 20
"rtploopback" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"ulpfec" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"raptorfec" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"mp4" x 38
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 4
"#\n" x 37
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 37
"[Nokia]" x 36
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 18
"[OMNA - Open Mobile Naming Authority=OMNA-OpenMobileNamingAuthority]" x 36
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 18
"ogg" x 34
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 2
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 1
"[OASIS]" x 34
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 17
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 17
"[Schubert]" x 34
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 17
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 17
"    #\n" x 33
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 33
"rtf" x 33
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:522 x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:521 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/types/cache.rb:62 x 1
"RFC5707" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16
"RFC2046" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16
"[3GPP]" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16

Retained String Report
-----------------------------------
"IANA" x 2824
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1412
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 1412
"application" x 2410
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 1205
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 1205
"base64" x 1527
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 1525
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 1
"audio" x 300
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 150
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 150
"video" x 188
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 94
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 94
"text" x 155
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 77
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 77
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 1
"[Murata]" x 148
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 74
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 74
"image" x 142
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 71
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 71
"8bit" x 68
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 67
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:70 x 1
"quoted-printable" x 64
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 62
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:71 x 1
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:55 x 1
"LTSW" x 49
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 49
"[W3C]" x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 21
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 21
"multipart" x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 21
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 21
"message" x 42
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 21
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 21
"RFC4856" x 40
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 20
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 20
"[OMNA - Open Mobile Naming Authority=OMNA-OpenMobileNamingAuthority]" x 36
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 18
"[Nokia]" x 36
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 18
"[Schubert]" x 34
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 17
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 17
"[OASIS]" x 34
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 17
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 17
"RFC2046" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16
"RFC5707" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16
"[3GPP]" x 32
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 16
"model" x 30
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 15
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 15
"RFC2045" x 30
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 15
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 15
"[Petersen]" x 30
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 15
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 15
"[Rauschenbach]" x 28
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 14
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 14
"[Hu]" x 28
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 14
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 14
"[Rae]" x 26
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 13
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 13
"[Dolan]" x 26
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 13
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 13
"[Martin]" x 26
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 13
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 13
"RFC3555" x 24
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 12
"RFC5934" x 22
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 11
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 11
"[D'Esclercs=DEsclercs]" x 22
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 11
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 11
"[Hattersley]" x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 9
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 9
"RFC6381" x 18
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 9
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 9
"[Siebert]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"[Yue]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"RFC6849" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"[Lindner]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"RFC4735" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"[Faure]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"[Patton]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"RFC5109" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"[Andersson]" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 8
"example" x 16
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 8
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 8
"[Joseph]" x 14
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 7
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 7
"[OMA-DM Work Group]" x 14
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 7
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 7
"mp4" x 14
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:224 x 4
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:632 x 3
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:629 x 3
"[OMA Push to Talk over Cellular (POC) Working Group]" x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 6
"[Steidl]" x 12
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/2.1.0/json/common.rb:155 x 6
    /home/sam/.rbenv/versions/2.1.0-github/lib/ruby/gems/2.1.0/gems/mime-types-2.0/lib/mime/type.rb:302 x 6
=> nil


```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog


### 0.0.4
- Added compatability with released version of Ruby 2.1.0
- Cleanup to use latest APIs available in 2.1.0

### 0.0.3
- Added string analysis
