import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { featuresAPI, votesAPI } from '@/lib/api';

export function useFeatures(page: number = 1, limit: number = 10) {
  return useQuery({
    queryKey: ['features', page, limit],
    queryFn: () => featuresAPI.getFeatures(page, limit),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useCreateFeature() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: featuresAPI.createFeature,
    onSuccess: () => {
      // Invalidate and refetch features queries
      queryClient.invalidateQueries({ queryKey: ['features'] });
    },
  });
}

export function useVoteFeature() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: votesAPI.vote,
    onSuccess: () => {
      // Invalidate and refetch features queries to update vote counts
      queryClient.invalidateQueries({ queryKey: ['features'] });
    },
  });
}

export function useRemoveVote() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: votesAPI.removeVote,
    onSuccess: () => {
      // Invalidate and refetch features queries to update vote counts
      queryClient.invalidateQueries({ queryKey: ['features'] });
    },
  });
}