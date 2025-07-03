import 'package:get/get.dart';
import 'package:mushiya_beauty/model/policy_model.dart';
import 'package:mushiya_beauty/utills/services.dart';

class PolicyController extends GetxController {
  final ApiServices _apiService = ApiServices();
  var privacyPolicy = Rxn<PolicyModel>(); // Single policy (nullable)
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchPrivacyPolicy();
    fetchShippingPrivacyPolicy();
    fetchTermsAndCondition();
    fetchContactUsList();
    fetchRefundPolicy();
    super.onInit();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _apiService.fetchPolicies();
      // Find the privacy policy by handle
      final privacyPolicy = response.policies.firstWhere(
        (policy) => policy.handle == 'privacy-policy',
        orElse: () => throw Exception('Privacy policy not found'),
      );
      this.privacyPolicy.value = privacyPolicy;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void retryFetch() {
    fetchPrivacyPolicy();
  }

  // shipping policy api call
  var shippingPrivacyPolicy = Rxn<PolicyModel>(); // Single policy (nullable)

  Future<void> fetchShippingPrivacyPolicy() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _apiService.fetchPolicies();
      // Find the privacy policy by handle
      final shippingPrivacyPolicy = response.policies.firstWhere(
        (policy) => policy.handle == 'shipping-policy',
        orElse: () => throw Exception('Shipping policy not found'),
      );
      this.shippingPrivacyPolicy.value = shippingPrivacyPolicy;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void retryShippingFetch() {
    fetchShippingPrivacyPolicy();
  }

  // terms and condition  api call
  var termsAndCondition = Rxn<PolicyModel>(); // Single policy (nullable)

  Future<void> fetchTermsAndCondition() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _apiService.fetchPolicies();
      // Find the privacy policy by handle
      final termsAndCondition = response.policies.firstWhere(
        (policy) => policy.handle == 'terms-of-service',
        orElse: () => throw Exception('Terms of service not found'),
      );
      this.termsAndCondition.value = termsAndCondition;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void retryTermsAndConditionFetch() {
    fetchTermsAndCondition();
  }

  // terms and condition  api call
  var contactUsList = Rxn<PolicyModel>(); // Single policy (nullable)

  Future<void> fetchContactUsList() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _apiService.fetchPolicies();
      // Find the privacy policy by handle
      final contactUsList = response.policies.firstWhere(
        (policy) => policy.handle == 'contact-information',
        orElse: () => throw Exception('Terms of service not found'),
      );
      this.contactUsList.value = contactUsList;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void retryContactUsList() {
    fetchContactUsList();
  }

  // refund policy  api call
  var refundPolicyList = Rxn<PolicyModel>(); // Single policy (nullable)

  Future<void> fetchRefundPolicy() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _apiService.fetchPolicies();
      // Find the privacy policy by handle
      final refundPolicyList = response.policies.firstWhere(
        (policy) => policy.handle == 'refund-policy',
        orElse: () => throw Exception('Refund Policy not found'),
      );
      this.refundPolicyList.value = refundPolicyList;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void retryrefundPolicy() {
    fetchRefundPolicy();
  }
}
