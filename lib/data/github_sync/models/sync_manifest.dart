enum ManifestComparison { remoteNewer, localNewer, equal }

ManifestComparison compareManifests(
  SyncManifest? local,
  SyncManifest remote,
) {
  if (local == null) return ManifestComparison.remoteNewer;

  if (remote.updatedAt.isAfter(local.updatedAt)) {
    return ManifestComparison.remoteNewer;
  }
  if (local.updatedAt.isAfter(remote.updatedAt)) {
    return ManifestComparison.localNewer;
  }
  if (remote.checksumSha256 != local.checksumSha256) {
    return ManifestComparison.localNewer;
  }
  return ManifestComparison.equal;
}

class SyncManifest {
  const SyncManifest({
    required this.updatedAt,
    required this.schemaVersion,
    required this.deviceId,
    required this.checksumSha256,
    required this.sizeBytes,
  });

  final DateTime updatedAt;
  final int schemaVersion;
  final String deviceId;
  final String checksumSha256;
  final int sizeBytes;

  factory SyncManifest.fromJson(Map<String, dynamic> json) {
    return SyncManifest(
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
      schemaVersion: json['schema_version'] as int,
      deviceId: json['device_id'] as String,
      checksumSha256: json['checksum_sha256'] as String,
      sizeBytes: json['size_bytes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'schema_version': schemaVersion,
      'device_id': deviceId,
      'checksum_sha256': checksumSha256,
      'size_bytes': sizeBytes,
    };
  }
}
