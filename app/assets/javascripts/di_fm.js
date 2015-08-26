/**************************************************************

 get_di_tracks:
 Grabs recent track list from Di.FM for selected channel
 and updates the saved tracks table.

 get_di_channels:
 Grabs list of Di.FM channels

 di_save_track_info:
 Saves selected track to database. From Sandbox mode, saving to the db is skipped.

 update_tracks_table
 Updates 'Saved Tracks' table with new track info.

 ***************************************************************/

function create_namespace(name){
    var names = name.split('.');
    var current = window;

    $.each(names, function(idx, name){
        current[name] = current[name] || {};
        current = current[name];
    });

    return current;
}

create_namespace('app.DiFM');


app.DiFM.CreateViewController = function() {
    var that = this;

    //#######################################
    // DI.FM stuff
    //#######################################
    this.di_track_form = $('#di_track_form');
    this.di_channel_select = $('#di_channel_select');
    this.di_error_div = $('#di_errors');
    this.di_track_list = $('#di_track_list');
    this.di_tracks_table = $('#di_fm_tracks_table');
    this.tracks_table_div = $('#track_table');

    // Get recent track history from channel
    $(this.di_track_form).submit(function(e){
        e.preventDefault();

        // Alert the user if they haven't selected a channel.
        if (_.isUndefined($(e.target).find(':selected').attr('value'))){
            var errorMesg = $(document.createElement('div'));
            errorMesg.attr('class', 'alert alert-danger').
                attr('id', 'user_alert').
                text('Please Select a Channel First.');

            $(that.di_error_div).append(errorMesg)
        }else{
            that.get_di_tracks(e);
        }
    });

    // Get list of channels
    this.get_di_channels();
}

app.DiFM.CreateViewController.prototype = {
    get_di_tracks: function(event){
        var that = this;
        var selected_channel = $(event.target).find(':selected').val();

        var data_url = '/di/channels/' + selected_channel + '/tracks';

        $.ajax({
            url: data_url,
            type: 'GET',
            dataType: 'json',
            beforeSend: function(){
                that.di_track_list.empty();
                that.di_track_list.text('Loading Tracks...');
            },
            success: function(data) {
                // Clear out existing track list
                that.di_track_list.empty();

                var channelInfoSpan = $(document.createElement('span'));
                channelInfoSpan.text('Recent Tracks from ' + data.channel.name);

                that.di_track_list.append("<br /><br />").
                    append(channelInfoSpan);

                _.each(data.recent_tracks, function(track, index){
                    the_index = index + 1;

                    var divTag = $(document.createElement('div'));
                    divTag.attr('class', 'track-list-item');

                    // Artist and Track info, with tooltips to show the alt artist/track info
                    // I've set it up this way because I save a lot of tracks from the
                    // Russian Club Hits channel and I wanted to have a way to see the info in Russian.
                    // Also, some track details are returned with encoding weirdness.

                    var artistSpanTag = $(document.createElement('span'));
                    artistSpanTag.attr('id', 'artist_' + the_index).
                        attr('class', 'track-tooltip track-artist').
                        attr('data-toggle', 'tooltip').
                        attr('data-placement', 'bottom').
                        attr('title', track.artist).
                        text('#' + the_index + ": " + track.display_artist);


                    var trackSpanTag = $(document.createElement('span'));
                    trackSpanTag.attr('id', 'track_' + the_index).
                        attr('class', 'track-tooltip').
                        attr('data-toggle', 'tooltip').
                        attr('data-placement', 'bottom').
                        attr('data-track-info', track.track).
                        attr('title', track.title).
                        text(' - ' + track.display_title);

                    var saveLink = $(document.createElement('button'));
                    saveLink.attr('class', 'btn btn-xs btn-primary').
                        text('Save');

                    saveLink.click(function(e) {
                        that.di_save_track_info(this);
                    });

                    // Activate tooltips
                    $(artistSpanTag).tooltip();
                    $(trackSpanTag).tooltip();

                    // Add the spans...
                    divTag.append(saveLink).
                        append(artistSpanTag).
                        append(trackSpanTag);

                    // Add 'now playing' badge
                    if (track.now_playing){
                        var nowPlayingBadge = $(document.createElement('span'));

                        nowPlayingBadge.attr('class', 'label label-success now-playing-badge').
                            text('now playing');

                        divTag.append(nowPlayingBadge);
                    }

                    // Append to track listing div
                    that.di_track_list.append(divTag);
                });
            },
            error: function (data, textStatus, errorThrown) {
                var errorDivTag = $(document.createElement('div'));
                errorDivTag.attr('class', 'alert alert-danger').
                    text('Error: ' + errorThrown);

                that.di_error_div.append(errorDivTag);
            }
        });
    },
    get_di_channels: function(){
        var that = this;
        var data_url = '/di/channels/list';

        $.ajax({
            url: data_url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                // Channel select list
                var channelSelect = $(document.createElement('select'));
                channelSelect.attr('id', 'channel_select_input').
                    attr('name', 'channel_id').
                    attr('required', true);

                // Add default option
                var emptyOption = $(document.createElement('option'));
                emptyOption.prop('selected', true).
                    text('Select a Channel');

                channelSelect.append(emptyOption);

                // Add options to the select
                _.each(data.channels, function(channel){
                    var channelOption = $(document.createElement('option'));
                    channelOption.attr('data-channel-name', channel.name).
                        attr('data-channel-id', channel.id).
                        attr('data-channel-url', channel.url).
                        attr('value', channel.id).
                        text(channel.name);

                    channelSelect.append(channelOption);
                });

                // Append to view
                that.di_channel_select.append(channelSelect);
            },
            error: function (data, textStatus, errorThrown) {
                var errorDivTag = $(document.createElement('div'));
                errorDivTag.attr('class', 'alert alert-danger').
                    text('Error: ' + errorThrown);

                that.di_error_div.append(errorDivTag);
            }
        });
    },
    di_save_track_info: function(item){
        var that = this;

        // Artist, song and track info
        var track_data = {
            track: {
                artist: _.last($(item).next().text().split(': ')),
                song: _.last($(item).next().next().text().split('- ')),
                track: $(item).next().next().attr('data-track-info'),
                channel: $('#channel_select_input :selected').text()
            }
        }

        $.ajax({
            url: '/di/tracks/save',
            type: 'POST',
            dataType: 'json',
            data: track_data,
            beforeSend: function(){
                $(item).text('Saving Track...');
            },
            success: function(data) {
                $(item).text('Track Saved').
                    attr('disabled', 'disabled');
                that.update_tracks_table(data);
            },
            error: function (data, textStatus, errorThrown) {
                var errorDivTag = $(document.createElement('div'));
                errorDivTag.attr('class', 'alert alert-danger').
                    text('Error: ' + errorThrown);

                that.di_error_div.append(errorDivTag);
            }
        });
    },
    update_tracks_table: function(track){
        var newTrackRow = $(document.createElement('tr'));

        /* Info cells */
        var artistCell = $(document.createElement('td'));
        var songCell = $(document.createElement('td'));
        var channelCell = $(document.createElement('td'));
        var dateCell = $(document.createElement('td'));

        /* Show/Edit/Destroy actions cells */
        var actionShowCell = $(document.createElement('td'));
        var actionEditCell = $(document.createElement('td'));
        var actionDestroyCell = $(document.createElement('td'));

        artistCell.text(track.artist);
        songCell.text(track.song);
        channelCell.text(track.channel);
        dateCell.text(_.first(track.created_at.split('T')));

        /* TODO: Make these actual action links */
        actionShowCell.text('Show');
        actionEditCell.text('Edit');
        actionDestroyCell.text('Destroy');

        /* Add new cells to the new row */
        newTrackRow.append(artistCell, songCell, channelCell, dateCell, actionShowCell, actionEditCell, actionDestroyCell);

        /* Add the new row to the track table */
        $(this.di_tracks_table).prepend(newTrackRow);
    }
}