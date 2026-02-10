import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPeminjamanController extends GetxController {
  var isLoading = false.obs;
  var detailList = [].obs;

  final supabase = Supabase.instance.client;

  Future<void> fetchDetail(int peminjamanId) async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('detail_peminjaman')
          .select()
          .eq('peminjaman_id', peminjamanId)
          .order('detail_peminjaman_id');

      detailList.value = response;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
