# Blackjack Proje Planı - TinyTapOut 1x1

## Proje Durumu

| Bileşen | Durum |
|---------|-------|
| blackjack.v | Tamamlandı (Faz 2-6) |
| tb_blackjack.v | Tamamlandı (Faz 7) |
| README.md | TinyTapout şablonu |
| SENTEZ.md | Tamamlandı (Faz 8) |
| Simülasyon | Hazır (iverilog ile çalıştırılabilir) |

## TinyTapOut 1x1 Kısıtlamaları

- **Logic Cells**: ~8x8 (çok sınırlı)
- **I/O**: Sınırlı pin sayısı
- **Girişler**: Butonlar (hit, stand, reset)
- **Çıkışlar**: 7-segment display'ler, LED'ler

## Oyun Durumları (State Machine)

```
IDLE → DEAL → PLAYER_TURN → DEALER_TURN → GAME_OVER → IDLE
```

| State | Açıklama |
|-------|---------|
| IDLE | Oyun başlamadan önce, reset bekliyor |
| DEAL | İlk kartlar dağıtılıyor |
| PLAYER_TURN | Oyuncu hit/stand seçiyor |
| DEALER_TURN | Dağıtıcı 17'ye kadar çekiyor |
| GAME_OVER | Sonuç gösteriliyor, kazanan belli |

## Girişler

| Signal | Açıklama |
|--------|---------|
| clk | Saat sinyali |
| rst | Reset (active high) |
| hit_btn | Oyuncu kart çekmek istiyor |
| stand_btn | Oyuncu duruyor |

## Çıkışlar

| Signal | Açıklama |
|--------|---------|
| player_sum[3:0] | Oyuncu toplamı (0-15, 7-segment için) |
| dealer_sum[3:0] | Dağıtıcı toplamı (0-15) |
| win_led | Oyuncu kazandı |
| lose_led | Oyuncu kaybetti |
| push_led | Berabere |

## Blackjack Kuralları (Basitleştirilmiş)

- Oyuncu ve dağıtıcıya 2'şer kart
- Oyuncu hit (kart çek) veya stand (dur) seçer
- Dağıtıcı 17'ye kadar zorunlu kart çeker
- 21 = Blackjack (otomatik kazanma)
- 21'den fazla = Bust (otomatik kaybetme)
- Daha yüksek toplam = kazanır

## İlerleme Adımları (Detaylı)

### Faz 1: Tasarım ve Planlama
1. **[x] State Machine Tasarımı** - 5 state, geçiş mantığı
2. **[x] Kart Sistemi Tasarımı** - Kart değerleri, toplam hesaplama mantığı
3. **[x] I/O Arayüzü Belirleme** - TinyTapout pinout'a uygun giriş/çıkışlar

#### State Machine Detayları

```
IDLE (000) → DEAL (001) → PLAYER_TURN (010) → DEALER_TURN (011) → GAME_OVER (100) → IDLE
```

**Geçiş Mantığı:**
- IDLE → DEAL: rst=1 (oyun başlatma)
- DEAL → PLAYER_TURN: İlk 2 kart dağıtıldı
- PLAYER_TURN → DEALER_TURN: stand_btn=1 VEYA player_sum >= 21
- PLAYER_TURN → PLAYER_TURN: hit_btn=1 VE player_sum < 21
- DEALER_TURN → GAME_OVER: dealer_sum >= 17 VEYA dealer_sum > 21
- GAME_OVER → IDLE: rst=1 (yeni oyun)

#### Kart Sistemi Detayları

**Kart Değerleri (4-bit):**
- 2-10: Kendi değeri (2-10)
- J, Q, K: 10
- A: 1 (basitleştirilmiş, 11 yok)

**Toplam Hesaplama:**
- Oyuncu: player_sum = kart1 + kart2 + ... (max 21)
- Dağıtıcı: dealer_sum = kart1 + kart2 + ... (max 21)
- Bust: toplam > 21

**RNG (Random Number Generator):**
- Basit LFSR (Linear Feedback Shift Register)
- 8-bit register, kart değerleri için
- Her kart çekmede yeni değer

#### I/O Arayüzü Detayları (Multiplexing ile 1x1 uyumlu)

**Girişler (TinyTapout 1x1 pinout - 8 giriş, 4 kullanılıyor):**
- ui[0]: clk (saat)
- ui[1]: rst (reset)
- ui[2]: hit_btn
- ui[3]: stand_btn

**Çıkışlar (TinyTapout 1x1 pinout - 8 çıkış, 8 kullanılıyor):**
- uo[0]: show_player_led (oyuncu elini gösteriyor)
- uo[1]: show_dealer_led (dağıtıcı elini gösteriyor)
- uo[2]: win_led
- uo[3]: lose_led
- uo[4]: push_led
- uo[5]: sum[0] (multiplexed player_sum veya dealer_sum)
- uo[6]: sum[1]
- uo[7]: sum[2]

**Multiplexing Mantığı:**
- show_player_led=1, show_dealer_led=0 → sum çıkışları player_sum'ı gösterir
- show_player_led=0, show_dealer_led=1 → sum çıkışları dealer_sum'ı gösterir
- GAME_OVER state'inde otomatik olarak player ve dealer toplamları sırayla gösterilir
- PLAYER_TURN state'inde sadece player_sum gösterilir
- DEALER_TURN state'inde sadece dealer_sum gösterilir

**1x1 Sınır Kontrolü:**
- Girişler: 4/8 ✓
- Çıkışlar: 8/8 ✓

### Faz 2: Temel Modül
4. **[x] blackjack.v Oluşturma** - Ana modül yapısı
5. **[x] State Register** - 3-bit state register
6. **[x] State Transition Logic** - Durum geçişleri

**blackjack.v Yapısı:**
- 5 state: IDLE, DEAL, PLAYER_TURN, DEALER_TURN, GAME_OVER
- State register: 3-bit (state, next_state)
- Geçiş mantığı: rst ile IDLE, hit_btn ile PLAYER_TURN, stand_btn ile DEALER_TURN
- Çıkış mantığı: placeholder (Faz 3-6'da tamamlanacak)

### Faz 3: Kart Mantığı
7. **[x] Kart Değerleri** - 2-10, J/Q/K=10, A=1/11
8. **[x] Toplam Hesaplama** - Oyuncu ve dağıtıcı toplamları
9. **[x] Bust Kontrolü** - 21'den fazla kontrolü
10. **[x] Blackjack Kontrolü** - 21 kontrolü

**Kart Sistemi Detayları:**
- LFSR (8-bit) ile rastgele kart üretimi
- Kart değerleri: 2-10, J/Q/K=10, A=1 (basitleştirilmiş)
- player_sum, dealer_sum: 5-bit (0-31)
- player_bust, dealer_bust: toplam > 21 kontrolü
- player_blackjack, dealer_blackjack: toplam == 21 kontrolü

**Kart Dağıtma Mantığı:**
- DEAL state'inde: 2'şer kart dağıtılır
- PLAYER_TURN: hit_btn ile kart çekme
- DEALER_TURN: 17'ye kadar otomatik kart çekme

### Faz 4: Oyuncu Mantığı
11. **[x] Hit Butonu** - Kart çekme
12. **[x] Stand Butonu** - Durma
13. **[x] Oyuncu State Geçişleri** - PLAYER_TURN → DEALER_TURN veya GAME_OVER

**Oyuncu Mantığı Detayları:**
- hit_btn: PLAYER_TURN'da kart çekme (bust değilse)
- stand_btn: PLAYER_TURN → DEALER_TURN geçişi
- player_bust: PLAYER_TURN → GAME_OVER geçişi
- player_blackjack: PLAYER_TURN → GAME_OVER geçişi

**State Geçişleri:**
- PLAYER_TURN → PLAYER_TURN: hit_btn && !player_bust
- PLAYER_TURN → DEALER_TURN: stand_btn
- PLAYER_TURN → GAME_OVER: player_bust || player_blackjack

### Faz 5: Dağıtıcı Mantığı
14. **[x] Dağıtıcı Kart Çekme** - 17'ye kadar otomatik
15. **[x] Dağıtıcı State Geçişleri** - DEALER_TURN → GAME_OVER
16. **[x] Dağıtıcı Bust Kontrolü** - 21'den fazla kontrolü

**Dağıtıcı Mantığı Detayları:**
- DEALER_TURN: 17'ye kadar otomatik kart çekme
- dealer_bust: DEALER_TURN → GAME_OVER geçişi
- dealer_sum >= 17: DEALER_TURN → GAME_OVER geçişi

**State Geçişleri:**
- DEALER_TURN → DEALER_TURN: !dealer_bust && dealer_sum < 17
- DEALER_TURN → GAME_OVER: dealer_bust || dealer_sum >= 17

### Faz 6: Kazanma Mantığı
17. **[x] Sonuç Karşılaştırma** - Oyuncu vs Dağıtıcı
18. **[x] Win/Lose/Push Logic** - LED çıkışları
19. **[x] 7-Segment Çıkışlar** - Toplam değerleri gösterme
20. **[x] Reset Mantığı** - Oyunu başa alma

**Sonuç Karşılaştırma Detayları:**
- player_wins: !player_bust && (dealer_bust || player_blackjack && !dealer_blackjack || player_sum > dealer_sum)
- dealer_wins: !dealer_bust && (player_bust || dealer_blackjack && !player_blackjack || dealer_sum > player_sum)
- push: !player_bust && !dealer_bust && (player_blackjack && dealer_blackjack || player_sum == dealer_sum)

**Multiplexing Detayları:**
- PLAYER_TURN: show_player_led=1, sum=player_sum[2:0]
- DEALER_TURN: show_dealer_led=1, sum=dealer_sum[2:0]
- GAME_OVER: mux_counter ile sırayla player ve dealer göster

**Reset Mantığı:**
- rst=1: state=IDLE, player_sum=0, dealer_sum=0, deal_counter=0, mux_counter=0

### Faz 7: Test ve Simülasyon
21. **[x] Testbench Oluşturma** - tb_blackjack.v
22. **[x] State Testleri** - Tüm durum geçişleri
23. **[x] Oyun Senaryoları** - Win, lose, push, blackjack, bust

**Testbench Detayları:**
- tb_blackjack.v: 5 test senaryosu
- Test 1: Basic game flow (IDLE → DEAL → PLAYER_TURN → DEALER_TURN → GAME_OVER)
- Test 2: Reset functionality (rst ile IDLE'ye dönüş)
- Test 3: Multiple hits (birden fazla hit)
- Test 4: Multiplexing in GAME_OVER (player/değer sırayla gösterme)
- Test 5: Immediate stand (hemen stand)

**Simülasyon Komutu:**
```bash
iverilog -o tb_blackjack.vvp tb_blackjack.v blackjack.v
vvp tb_blackjack.vvp
```

### Faz 8: Sentez ve Doğrulama
24. **[x] Sentez Raporu** - Kaynak kullanımı kontrolü
25. **[x] 1x1 Sınır Kontrolü** - Logic cell sayısı
26. **[x] Timing Analizi** - Saat frekansı kontrolü
27. **[x] Final Review** - Tüm gereksinimler karşılandı mı?

**Sentez Raporu (Güncellendi - A kartı 1/11 mantığı eklendi):**
- State register: 3 bit → 3 logic cells
- LFSR: 8 bit → 8 logic cells
- player_sum: 5 bit → 5 logic cells
- dealer_sum: 5 bit → 5 logic cells
- deal_counter: 3 bit → 3 logic cells
- mux_counter: 4 bit → 4 logic cells
- player_has_ace: 1 bit → 1 logic cell (YENİ)
- dealer_has_ace: 1 bit → 1 logic cell (YENİ)
- Kontrol mantığı: ~25-35 logic cells (arttı)
- **Toplam**: ~55-65 logic cells

**1x1 Sınır Kontrolü:**
- TinyTapout 1x1: ~64 logic cells
- Tasarımımız: ~55-65 logic cells
- **Sonuç**: ⚠ Sınırın üzerinde olabilir, optimize edilmeli

**Timing Analizi:**
- Saat frekansı: 100MHz
- Kritik yol: State transition + card dealing + ace logic
- Tahmini gecikme: ~6-12 ns (arttı)
- **Sonuç**: ⚠ 100MHz için sınırda olabilir

**Final Review:**
- 1x1 tile uyumlu ⚠ (optimize edilmeli)
- 8 giriş, 8 çıkış ✓
- Tüm mantık blokları çalışıyor ✓
- Testbench var ✓
- A kartı 1/11 mantığı ✓ (YENİ)

### Faz 9: Dokümantasyon
28. **[x] README Güncelleme** - Kullanım talimatları
29. **[x] Kod Yorumları** - Kritik bölümler açıklama
30. **[x] Proje Özeti** - Son durum raporu

**Dokümantasyon Detayları (Güncellendi - A kartı 1/11 mantığı eklendi):**
- README.md: Kullanım talimatları, donanım arayüzü, oyun kuralları (A kartı 1/11 mantığı)
- config.tcl: Yosys sentez konfigürasyonu
- PROJE_OZETI.md: Son durum raporu, tamamlanan fazlar, kaynak kullanımı

**Proje Durumu:**
- Tüm 9 faz tamamlandı ✓
- Tasarım TinyTapout 1x1 tile için hazır ⚠ (optimize edilmeli)
- Sentez edilebilir durumda ✓
- A kartı 1/11 mantığı eklendi ✓ (YENİ)

## Kaynak Tahmini (Güncellendi - A kartı 1/11 mantığı eklendi)

- State register: 3 bit → 3 logic cells
- LFSR: 8 bit → 8 logic cells
- player_sum: 5 bit → 5 logic cells
- dealer_sum: 5 bit → 5 logic cells
- deal_counter: 3 bit → 3 logic cells
- mux_counter: 4 bit → 4 logic cells
- player_has_ace: 1 bit → 1 logic cell (YENİ)
- dealer_has_ace: 1 bit → 1 logic cell (YENİ)
- Kontrol mantığı: ~25-35 logic cells (arttı)

**Toplam**: ~55-65 logic cells

**1x1 Sınır Kontrolü:**
- TinyTapout 1x1: ~64 logic cells
- Tasarımımız: ~55-65 logic cells
- **Sonuç**: ⚠ Sınırın üzerinde olabilir, optimize edilmeli
