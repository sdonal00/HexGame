# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends VBoxContainer

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()

signal hide_ad()
signal earned_respawn()

func _ready():
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
		
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		destroy()
		
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
		
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
		
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
		
	$Load.visible = false
	$Show.visible = false
	$Destroy.visible = false

func _on_load_pressed():
	load_ad()

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	rewarded_ad.full_screen_content_callback = full_screen_content_callback

	var server_side_verification_options := ServerSideVerificationOptions.new()
	server_side_verification_options.custom_data = "TEST PURPOSE"
	server_side_verification_options.user_id = "user_id_test"
	rewarded_ad.set_server_side_verification_options(server_side_verification_options)
	self.rewarded_ad = rewarded_ad
	show_ad()

func show_ad():
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		
func load_ad():
	RewardedAdLoader.new().load("ca-app-pub-2052202810347689/1688011834", AdRequest.new(), rewarded_ad_load_callback)

func on_user_earned_reward(rewarded_item : RewardedItem):
	earned_respawn.emit()

func _on_destroy_pressed():
	destroy()

func destroy():
	hide_ad.emit()
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null #need to load again
