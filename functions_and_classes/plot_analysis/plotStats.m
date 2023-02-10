
function  [] = plotStats(trainingStats)
    import java.text.SimpleDateFormat
    import java.lang.String
    import java.util.Calendar.*
    import java.text.DateFormat
    dateFormat = SimpleDateFormat(String("HH:mm:ss"));
    reference = dateFormat.parse("00:00:00");

    times_ = zeros(1,length(trainingStats.TimeStamp));
    previous_ = 0;
    last_add_ = 0;
    for iter = 1 : length(trainingStats.TimeStamp)
        date = dateFormat.parse(String(trainingStats.TimeStamp(iter)));
        times_temp_ =  (date.getTime() - reference.getTime())/1000/60;
        if times_temp_ < previous_
             last_add_ = last_add_ + previous_;
         end
        times_(iter) = times_temp_;
        previous_ = times_temp_;
    end

    figure
    tiledlayout(2,1, 'Padding', 'none', 'TileSpacing', 'compact');
    nexttile
        date = dateFormat.parse(String(trainingStats.TimeStamp(end)));
        times_temp_ =  (date.getTime() - reference.getTime())/1000/60;
        plot(times_); title(['Time t_{all} = ' char(string(last_add_+times_temp_)) ])
    nexttile
        plot(trainingStats.AverageReward); hold on;
        plot(trainingStats.EpisodeReward,':'); hold off;
        title("Rewards")
%     nexttile
%         plot(trainingStats.EpisodeQ0)
%         title("Q_0")
   figure_var_called_new_figure_pos;
end




