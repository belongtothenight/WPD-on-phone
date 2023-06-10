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
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib.patches import Ellipse

# matplotlib.use("agg")


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
        self.nn_intervals_list = nn_intervals_list
        # plot_distrib(nn_intervals_list)
        # plot_poincare(nn_intervals_list)
        # print(self.interpolated_nn_intervals)
        plot_psd(interpolated_nn_intervals, method="welch")
        plot_psd(interpolated_nn_intervals, method="lomb")

    def plot_distrib(self, path):
        plt.clf()
        plt.figure(figsize=(10, 10))
        plt.hist(self.nn_intervals_list, bins=100)
        plt.xlabel("Distribution of RR intervals (ms)")
        plt.ylabel("Number of RR intervals per bin")
        plt.title("Distribution of RR intervals")
        plt.savefig(
            path + "_distrib.png",
            dpi=300,
        )

    def plot_poincare(self, path):
        plt.clf()
        rr = np.array(self.nn_intervals_list)
        rr_n = rr[:-1]
        rr_n1 = rr[1:]

        sd1 = np.sqrt(0.5) * np.std(rr_n1 - rr_n)
        sd2 = np.sqrt(0.5) * np.std(rr_n1 + rr_n)

        m = np.mean(rr)
        min_rr = np.min(rr)
        max_rr = np.max(rr)

        plt.figure(figsize=(10, 10))
        plt.title("Poincare plot")

        sns.scatterplot(x=rr_n, y=rr_n1, color="#51A6D8")

        plt.xlabel(r"$RR_n (ms)$")
        plt.ylabel(r"$RR_{n+1} (ms)$")

        e1 = Ellipse(
            (m, m), 2 * sd1, 2 * sd2, angle=-45, linewidth=1.2, fill=False, color="k"
        )
        plt.gca().add_patch(e1)

        plt.arrow(
            m,
            m,
            (max_rr - min_rr) * 0.4,
            (max_rr - min_rr) * 0.4,
            color="k",
            linewidth=0.8,
            head_width=5,
            head_length=5,
        )
        plt.arrow(
            m,
            m,
            (min_rr - max_rr) * 0.4,
            (max_rr - min_rr) * 0.4,
            color="k",
            linewidth=0.8,
            head_width=5,
            head_length=5,
        )

        plt.arrow(
            m, m, sd2 * np.sqrt(0.5), sd2 * np.sqrt(0.5), color="green", linewidth=5
        )
        plt.arrow(
            m, m, -sd1 * np.sqrt(0.5), sd1 * np.sqrt(0.5), color="red", linewidth=5
        )

        plt.text(max_rr, max_rr, "SD2", fontsize=20, color="green")
        plt.text(
            m - (max_rr - min_rr) * 0.4 - 20, max_rr, "SD1", fontsize=20, color="red"
        )

        plt.savefig(
            path + "_poincare.png",
            dpi=300,
        )

        return sd1, sd2


if __name__ == "__main__":
    config = Config()
    data = readCSV(config.filePath)
    c = ConvertHRV(data)
    c.plot_distrib("./")
    c.plot_poincare("./")
