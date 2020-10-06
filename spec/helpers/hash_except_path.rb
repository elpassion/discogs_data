module Helpers
  def hash_except_path(hash, path)
    return hash.dup.tap { |h| h.delete(path.first) } if path.size == 1

    hash.each_with_object({}) do |(k, v), h|
      h[k] = if k == path.first
        case v
        when Hash  then hash_except_path(v, path.drop(1))
        when Array then v.map { |e| e.is_a?(Hash) ? hash_except_path(e, path.drop(1)) : e }
        else v
        end
      else
        v
      end
    end
  end

  def hash_except_paths(hash, paths)
    paths.each { |path| hash = hash_except_path(hash, path) }

    hash
  end
end
