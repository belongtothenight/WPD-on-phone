from hrvanalysis import (
    remove_outliers,
    remove_ectopic_beats,
    interpolate_nan_values,
    plot_psd,
    plot_distrib,
    plot_poincare,
)
import os
from config import Config
import matplotlib

matplotlib.use("agg")


def readCSV(path):
    import pandas as pd

    df = pd.read_csv(path, header=None)
    data = df[df.columns[0]].values.tolist()
    data = [float(i) for i in data]
    return data


class ConvertHRV:
    def __init__(self, BPM_data):
        rr_interval = [int(60 / i * 1000) for i in BPM_data]
        rr_intervals_without_outliers = remove_outliers(
            rr_intervals=rr_interval, low_rri=300, high_rri=2000
        )
        interpolated_rr_intervals = interpolate_nan_values(
            rr_intervals=rr_intervals_without_outliers, interpolation_method="linear"
        )
        nn_intervals_list = remove_ectopic_beats(
            rr_intervals=interpolated_rr_intervals, method="malik"
        )
        interpolated_nn_intervals = interpolate_nan_values(
            rr_intervals=nn_intervals_list
        )
        print(nn_intervals_list)
        # plot_distrib(nn_intervals_list)
        # plot_poincare(nn_intervals_list)
        self.nn_intervals_list = nn_intervals_list

    def plot_distrib(self):
        pass

    def plot_poincare(self):
        pass


if __name__ == "__main__":
    config = Config()
    data = readCSV(config.filePath)
    ConvertHRV(data)
