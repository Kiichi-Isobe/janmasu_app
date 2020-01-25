module ApplicationHelper
  def human_time(time)
    time.strftime('%y年%m月%d日%H時%M分')
  end
end
