import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/surah_controller.dart';
import '../helpers/surah_data_helper.dart';  // Import the helper

class SurahDetailPage extends StatelessWidget {
  SurahDetailPage({Key? key}) : super(key: key);

  final controller = Get.find<SurahController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // Get the surah number from the controller
          final surahNumber = controller.surahData['surah_number'];
          if (surahNumber != null) {
            // Convert to int and subtract 1 to get the correct index for the array
            final index = int.parse(surahNumber.toString()) - 1;
            // Use the Bangla name from SurahHelper
            if (index >= 0 && index < SurahHelper.banglaNames.length) {
              return Text(SurahHelper.banglaNames[index]);
            }
          }
          return const Text('সূরা বিবরণ'); // 'Surah Details' in Bangla
        }),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Surah header with number and name
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Obx(() => Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'সূরা নং ${controller.surahData['surah_number'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'SolaimanLipi'
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'আয়াত সংখ্যাঃ ${controller.surahData['total_ayahs'] ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SolaimanLipi'
                  ),
                ),
              ],
            )),
          ),
          
          // Bismillah section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Arabic Bismillah
                const Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Scheherazade',
                    height: 1,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 5),
                // Bangla translation
                const Text(
                  'শুরু করছি আল্লাহ্‌র নামে, যিনি পরম করুণাময়, অতি দয়ালু।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'SolaimanLipi'
                  ),
                ),
              ],
            ),
          ),
          
          // Ayah content - scrollable
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var ayahs = controller.surahData['ayah'] ?? [];
              if (ayahs.isEmpty) {
                return const Center(child: Text('No ayahs available'));
              }

              return ListView.builder(
                itemCount: ayahs.length,
                padding: const EdgeInsets.only(bottom: 100), // Add padding for player
                itemBuilder: (context, index) {
                  return Obx(() => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controller.currentAyahIndex.value == index 
                          ? Colors.teal.withOpacity(0.1) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.currentAyahIndex.value == index 
                            ? Colors.teal 
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayah number badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'আয়াত নম্বরঃ ${index + 1}',
                            style: const TextStyle(
                              fontFamily: 'SolaimanLipi'
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Ayah text/image
                        GestureDetector(
                          onTap: () => controller.playAyah(index),
                          child: Center(
                            child: Image.network(
                              'https://quran.sayed.page${ayahs[index]['img']}',
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / 
                                          loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback for when image fails to load
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        'صورة تعذر تحميلها',
                                        style: TextStyle(
                                          fontFamily: 'Scheherazade',
                                          fontSize: 22,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'ছবি লোড করা যায়নি। অডিও চালাতে ট্যাপ করুন।',
                                        style: TextStyle(
                                          fontFamily: 'SolaimanLipi',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildAudioPlayer(),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress slider
          Obx(() => Slider(
            value: controller.progress.value,
            onChanged: (value) => controller.seekTo(value),
            activeColor: Colors.teal,
            inactiveColor: Colors.grey[300],
          )),
          
          // Player controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 36),
                onPressed: () => controller.playPreviousAyah(),
              ),
              const SizedBox(width: 20),
              
              // Play/Pause button
              Obx(() => Container(
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: () => controller.togglePlayPause(),
                ),
              )),
              const SizedBox(width: 20),
              
              // Next button
              IconButton(
                icon: const Icon(Icons.skip_next, size: 36),
                onPressed: () => controller.playNextAyah(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}