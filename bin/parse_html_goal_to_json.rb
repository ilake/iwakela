#!/usr/bin/env script/runner

require 'rubygems'
require 'hpricot'

Goal.find(:all).each do |g|
  if g.name.blank? && g.comment.blank?
    g.destroy
  elsif g.name.blank? && !g.comment.blank?
    begin 
      g.name = g.comment
      g.save!
    rescue ActiveRecord::RecordInvalid, Exception => e
      g.destroy
    end
  end
end

Record.find(:all).each do |record|
# record = Record.find(55380)
  html = record.com_goal 

  if !html.blank?
    doc = Hpricot.parse(html)

    todo_status = []

    doc.search('img').each do |img|
      todo_status << img.attributes['alt']
    end

    doc.search('img').remove

    todo_name = []
    todo_comment = []
    doc.search('div').each do |div|
      todo_and_comment = div.inner_html.split(":\s")
      todo_name << todo_and_comment[0]
      todo_comment << todo_and_comment[1]
    end

    hash = {}
    #建立goal_details
    todo_name.each_with_index do |name,i|
      done = todo_status == 'Plus' ? 1 : 0
      goal = record.user.goals.find_by_name(name)
      goal_id = goal ? goal.id : nil
      goal_type = goal_id ? 'daily' : 'once'

      if goal_type == 'once'
        goal_id = record.user.goals.find_or_create_by_name('once').id
      end

      #once 的幫他create 一個叫做  once 的 goal, 沒name 的就用comment 代 都沒的就刪掉

      record.goal_details.create(:user_id => record.user.id, :name => name, :goal_id => goal_id, :comment => todo_comment[i], :done => done, :value => 0, :goal_type => goal_type, :rank => i, :created_at => record.todo_time, :updated_at => record.todo_time)
    end

  end
  record.update_attributes(:title => "#{record.todo_time.to_s(:md)}日誌")
end
