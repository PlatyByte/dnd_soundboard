import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soundboard_app/app/model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'select_video_state.dart';

class SelectVideoCubit extends Cubit<SelectVideoState> {
  SelectVideoCubit() : super(const SelectVideoState([])) {
    loadVideos();
  }

  final _supabase = Supabase.instance.client;

  Future<void> loadVideos() async {
    final videos = await _supabase
        .from('videos')
        .select<List<Map<String, dynamic>>>()
        .eq('active', true);

    emit(SelectVideoState(videos.map(SoundboardVideo.fromSupabase).toList()));
  }

  Future<void> changeCurrentPlaying(SoundboardVideo video) async {
    await _supabase
        .from('current_mood')
        .update(video.toMoodMap())
        .eq('index', '1');
  }
}
