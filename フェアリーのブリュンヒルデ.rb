#! /usr/bin/env ruby
# encoding: UTF-8

#
# Copyright 2014 Chen Ruichao <linuxer.sheep.0x@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

=begin
被B站的 妖精的布伦希尔特 戳到笑点，于是做了这个娱乐脚本
（其实我们以前也有一个 只有神不在的星期天 的梗，不过这个不是简单的文本组合，需要额外的rules，所以比较困难）

草草写的代码，求不D飞

TODO 冷门番不参与随机
TODO 处理含有多个“的”的标题（e.g.: 天降之物 永远的我的鸟笼 ）
TODO 说不定不带“的”的名字也很好玩？（“foo与bar”、“foo之bar”、“foo者bar”都可以试试看。不带关键字的也可以试试）
TODO 加入一些（人工的）语义分析效果会更好。例如:
            - “最近，”可以接任何句子
            - “进击的”通常接人名
            - “没能成为foo的bar无可奈何决定去baz”作为一个独立的模板，用来填空
=end

# workaround
class String
  def width
    w = 0
    self.scan(/[[:ascii:]]/ ) { w+=1 }
    self.scan(/[^[:ascii:]]/) { w+=2 } # Just a workaround; not always correct.
    w
  end

  def ljust_utf8(d)
    rest = d - self.width
    rest = 0 if rest < 0
    self + ' ' * rest
  end
end

$anime_list = []

ARGV.empty? and ARGV.push('default')
started = false
ARGF.each_line {|a|
  if started
    a.include? '的' and $anime_list << a.chomp
  elsif a.chomp == '=begin'
    started = true
  end
}

x = $anime_list.sample
y = $anime_list.sample
x or abort 'error: 您输入的所有动画标题均不含"的"，无法随机'

wat = x.partition('的').first + '的' + y.partition('的').last
puts( wat.ljust_utf8(30) + '  (%s x %s)' % [x, y] )
